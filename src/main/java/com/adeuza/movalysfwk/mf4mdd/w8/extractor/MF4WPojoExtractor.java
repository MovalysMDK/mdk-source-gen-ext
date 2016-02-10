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
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import com.a2a.adjava.AdjavaException;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlStereotype;
import com.a2a.adjava.uml2xmodele.extractors.PojoExtractor;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MEntityInterface;
import com.a2a.adjava.xmodele.MIdentifierElem;
import com.a2a.adjava.xmodele.MPackage;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WEntityImpl;

public class MF4WPojoExtractor extends PojoExtractor {
	
	public MF4WPojoExtractor() {
		super();
	}
	
	/**
	 * Create MInterface from MClass
	 * @param p_oMClass MClass from which to create MInterface
	 * @return MInterface of MClass
	 */
	@Override
	protected MEntityInterface extractInterfaceFromClass(MEntityImpl p_oMClass) {

		// calcul le package de l'interface
		MPackage oBasePackage = p_oMClass.getPackage();
		if (getLngConfiguration().getImplSubPackageName() != null
				&& getLngConfiguration().getImplSubPackageName().length() > 0) {
			oBasePackage = p_oMClass.getPackage().getParent();
		}

		MPackage oPackageInterface = oBasePackage;
		if (getLngConfiguration().getInterfaceSubPackageName() != null
				&& getLngConfiguration().getInterfaceSubPackageName().length() > 0) {
			oPackageInterface = oBasePackage.getChildPackage(getLngConfiguration()
					.getInterfaceSubPackageName());
			if (oPackageInterface == null) {
				oPackageInterface = new MPackage(getLngConfiguration().getInterfaceSubPackageName(),
						oBasePackage);
				oBasePackage.addPackage(oPackageInterface);
			}
		}

		// calcul le nom de l 'interface
		StringBuilder oInterfaceName = new StringBuilder();
		if ( this.getLngConfiguration().getInterfaceNamingPrefix() != null ) {
			oInterfaceName.append(this.getLngConfiguration().getInterfaceNamingPrefix());
		}
		oInterfaceName.append(p_oMClass.getEntityName());
		if ( this.getLngConfiguration().getInterfaceNamingSuffix() != null ) {
			oInterfaceName.append(this.getLngConfiguration().getInterfaceNamingSuffix());
		}

		MEntityInterface r_oInterface = new MEntityInterface(oInterfaceName.toString(), oPackageInterface);

		// cree les accesseurs a partir de la cle primaire
		for (MIdentifierElem oMIdentifierElem : p_oMClass.getIdentifier().getElems()) {
			if (oMIdentifierElem instanceof MAttribute) {
				createAccessorsFromAttribute((MAttribute) oMIdentifierElem, r_oInterface);
			}
		}

		for (MAttribute oAttribute : p_oMClass.getAttributes()) {
			createAccessorsFromAttribute(oAttribute, r_oInterface);
		}

		p_oMClass.setMasterInterface(r_oInterface);
		getDomain().getDictionnary().registerInterface(r_oInterface, p_oMClass);
		return r_oInterface;
	}
	
	@Override
	protected MF4WEntityImpl convertUmlClass(UmlClass p_oClass) throws AdjavaException {
		MF4WEntityImpl mf4wEntity = (MF4WEntityImpl) super.convertUmlClass(p_oClass);
		for(UmlStereotype us : p_oClass.getStereotypes()){
			if(us.getName().startsWith(MF4WExpandableTypeProcessor.COMPLEX_ENTITY_W8)) {
				mf4wEntity.setCreateFromExpandableProcessor(true);
				String [] entityInfos = us.getName().split(";");
				String sPackage = entityInfos[2].substring(0, entityInfos[2].lastIndexOf('.'));
				String sName = entityInfos[2].substring(entityInfos[2].lastIndexOf('.')+1);
				String sOriginEntityPackage = entityInfos[1].substring(0, entityInfos[1].lastIndexOf('.'));
				String sOriginEntityName = entityInfos[1].substring(entityInfos[1].lastIndexOf('.')+1);
				mf4wEntity.setPackageFromExpandableProcessor(sPackage);
				mf4wEntity.setClassFromExpandableProcessor(sName);
				mf4wEntity.setOriginPackageFromExpandableProcessor(sOriginEntityPackage);
				mf4wEntity.setOriginClassFromExpandableProcessor(sOriginEntityName);
				mf4wEntity.setOriginAttributeFromExpandableProcessor(entityInfos[3]);
			}
		}
		return mf4wEntity;
	}
}
