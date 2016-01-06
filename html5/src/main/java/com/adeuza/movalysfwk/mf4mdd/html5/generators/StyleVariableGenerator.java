/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.html5.generators;

import java.util.HashMap;
import java.util.Map;

import com.a2a.adjava.languages.html5.xmodele.MH5Dictionary;
import com.a2a.adjava.languages.html5.xmodele.MH5ScreenView;
import com.a2a.adjava.languages.html5.xmodele.MH5View;
import org.dom4j.Branch;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.GeneratorUtils;
import com.a2a.adjava.generator.core.injection.AbstractInjectionGenerator;
import com.a2a.adjava.generator.core.injection.FilePartGenerationConfig;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HModelFactory;

public class StyleVariableGenerator extends AbstractInjectionGenerator<MF4HDomain<MF4HDictionary, MF4HModelFactory>> {

    /**
     * Logger
     */
    private static final Logger log = LoggerFactory.getLogger(StyleVariableGenerator.class);

    @Override
    public void genere(XProject p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
        log.debug("> StyleVariableGenerator.genere");
        Chrono oChrono = new Chrono(true);
        this.createVariable(p_oMProject, p_oGeneratorContext);
        log.debug("< StyleVariableGenerator.genere: {}", oChrono.stopAndDisplay());
    }

    private void createVariable(XProject p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {

        Element r_xStyle = DocumentHelper.createElement("style");
        Element variables = r_xStyle.addElement("variables");

        this.addWorkspaceColumnsVariable(p_oMProject, variables);

        Document xViewModelDoc = DocumentHelper.createDocument(r_xStyle);
        String sTargetFile = "webapp/src/assets/styles/variables.scss";

        log.debug("  generation du fichier variable.scss");
        FilePartGenerationConfig oFilePartGenerationModuleDeclaration = new FilePartGenerationConfig("variable-declaration", "styles/variable-declaration.xsl", xViewModelDoc);
        this.doInjectionTransform(sTargetFile, p_oMProject, p_oGeneratorContext, oFilePartGenerationModuleDeclaration);


        //android ne compile pas sinon touver une autre solution
        if (isDebug()) {
            GeneratorUtils.writeXmlDebugFile(xViewModelDoc, sTargetFile + ".xml", p_oMProject);
        }

    }

    private void addWorkspaceColumnsVariable(XProject p_oMProject, Element p_oVariables) {
        Map<String, Integer> workspaceMap = new HashMap<>();

        MH5Dictionary dictionary = (MH5Dictionary) p_oMProject.getDomain().getDictionnary();

        for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
            if (oScreen.isWorkspace()) {
                MH5ScreenView screenView = (MH5ScreenView) dictionary.getMH5ViewFromName(oScreen.getName());
                workspaceMap.put(oScreen.getName(), screenView.getWorkSpaceColumnNumber());
            }
        }

        if (!workspaceMap.isEmpty()) {
            Element workspaceStyles = p_oVariables.addElement("variable");

            workspaceStyles.addAttribute("name", "application-workspace-styles");

            for (String key : workspaceMap.keySet()) {
                Element style = workspaceStyles.addElement("mapkey");
                style.addAttribute("name", key);
                Element subvar = style.addElement("mapkey");
                subvar.addAttribute("name", "workspace-columns-number");
                subvar
                        .setText(
                                String.valueOf(workspaceMap.get(key))
                        );
            }
        }
    }

}
