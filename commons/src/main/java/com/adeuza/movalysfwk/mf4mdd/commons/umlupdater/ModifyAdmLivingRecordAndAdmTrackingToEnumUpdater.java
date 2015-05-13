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
package com.adeuza.movalysfwk.mf4mdd.commons.umlupdater;

import java.util.Collection;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.uml.UmlAttribute;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlDataType;
import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml.UmlOperation;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

/**
 * <p>Update attribute type of adm fields (replace primitive types with enumeration MLiving)</p>
 * <p>Copyright (c) 2009
 * <p>Company: Adeuza
 *
 * @author mmadigand
 *
 */
public class ModifyAdmLivingRecordAndAdmTrackingToEnumUpdater extends AbstractUmlUpdater {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(ModifyAdmLivingRecordAndAdmTrackingToEnumUpdater.class);

	/**
	 * Suffix of method used to retreive entities by AdmLivingRecord
	 */
	private static final String CRITERIA_LIVINGRECORD = "_By_AdmLivingRecord";

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.umlupdater.UmlUpdater#execute(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.uml.UmlModel, java.util.Map)
	 */
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession) throws Exception {
		log.debug("> ModifyAdmLinvingRecordAndAdmTrackingToEnumUpdater.execute()");
		
		UmlDictionary oUmlDictionnary = p_oUmlModele.getDictionnary();
		Collection<UmlClass> oUmlClassList = oUmlDictionnary.getAllClasses();
		
		UmlDataType oMLivingDataType = new UmlDataType("com.adeuza.movalys.fwk.core.beans.MLiving");
		UmlDataType oMTrackingDataType = new UmlDataType("com.adeuza.movalys.fwk.core.beans.MTracking");
				
		String sAttributeName = null;
		for (UmlClass oUmlClass : oUmlClassList ) {
			for (UmlAttribute oUmlAttribute : oUmlClass.getAttributes()) {
				sAttributeName = oUmlAttribute.getName();
				if("admLivingRecord".equals(sAttributeName)){
					oUmlAttribute.setDataType(oMLivingDataType);
					oUmlClass.addOperation(new UmlOperation("getList" + oUmlClass.getName() + CRITERIA_LIVINGRECORD, oUmlClass));
				}
				else if("admTracking".equals(sAttributeName)){
					oUmlAttribute.setDataType(oMTrackingDataType);
				}
			}
		}
		
		log.debug("< ModifyAdmLinvingRecordAndAdmTrackingToEnumUpdater.execute()");
	}

}
